# fast_read_lines.R
# Memory efficient import of text files
#
fast_read_lines <- function(filename) {
  size <- file.info(filename)$size
  buf <- readChar(filename, size, useBytes = TRUE)
  line <- strsplit(buf, "\n", fixed = TRUE, useBytes = TRUE)[[1]]
  str_replace_all(line, "[\r]", "")
}
