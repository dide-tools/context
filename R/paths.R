## Helpers for paths
path_version <- function(path_root) {
  file.path(path_root, "context_version")
}
path_db <- function(path_root) {
  file.path(path_root, "db")
}
path_config <- function(path_root) {
  file.path(path_root, "context_config")
}
path_bin <- function(path_root) {
  file.path(path_root, "bin")
}
path_id <- function(path_root) {
  file.path(path_root, "id")
}

## TODO: together with r_platform_name, this needs to deal with the
## case of mac binaries (macosx/mavericks is not a good name here).
path_library <- function(path_root, platform = NULL, version = NULL) {
  if (is.null(version)) {
    version_str <- as.character(r_version(2))
  } else {
    if (!inherits(version, "numeric_version")) {
      version <- numeric_version(version)
    }
    version_str <- as.character(version[1, 1:2])
  }
  ## TODO: consider this - is it still what we want?
  platform_str <- r_platform_name(platform)
  file.path(path_root, "lib", platform_str, version_str)
}

is_absolute_path <- function(path) {
  grepl("^(/|[A-Za-z]:[/\\]|//|\\\\\\\\)", path)
}
is_relative_path <- function(path) {
  !is_absolute_path(path)
}

## This does not handle the case of a file /a/b/c and working
## directory of the same.
relative_paths <- function(filename, dir=getwd()) {
  msg <- !file.exists(filename)
  if (any(msg)) {
    stop("files do not exist: ", paste(filename[msg], collapse = ", "))
  }

  filename_abs <- clean_path(normalizePath(filename))
  dir <- clean_path(normalizePath(dir))

  ok <- string_starts_with(filename_abs, paste0(dir, "/"))
  if (!all(ok)) {
    stop("files above working directory: ",
         paste(filename[!ok], collapse = ", "))
  }

  substr(filename_abs, nchar(dir) + 2L, nchar(filename_abs))
}

clean_path <- function(x) {
  sub("/+$", "", gsub("\\", "/", x, fixed = TRUE))
}
