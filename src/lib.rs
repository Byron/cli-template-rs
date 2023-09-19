#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("{0}")]
    Bug(&'static str),
    #[error("{0}")]
    Message(String),
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

pub type Result<T> = std::result::Result<T, Error>;

pub fn fun(path: &std::path::Path) -> Result<()> {
    std::fs::read(path)?;
    Ok(())
}
