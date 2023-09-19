use anyhow::Context;
use clap::Parser;

mod options {
    use std::path::PathBuf;

    #[derive(Debug, clap::Parser)]
    #[structopt(name = "example", about = "An example of StructOpt usage.")]
    pub struct Args {
        /// Activate debug mode
        #[clap(short = 'd', long)]
        pub debug: bool,
        /// Set speed
        #[clap(short = 's', long, default_value = "42")]
        pub speed: f64,
        /// Input file
        pub input: PathBuf,
        /// Output file, stdout if not present
        pub output: Option<PathBuf>,
    }
}

fn main() -> anyhow::Result<()> {
    let opt = options::Args::parse();
    println!("{:?}", opt);
    let path = opt.output.unwrap_or("foo.txt".into());
    foobar::fun(&path).with_context(|| format!("Could not handle file at path {}", path.display()))
}
