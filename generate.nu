rm -rf src
mkdir src

# generate the enums
for $i in 0..255 {
    ([  "#[repr(u8)]",
        $"pub enum u8lte($i) {"]
        | append (0..$i | each { $"    _($in) = ($in)," })
        | append "}"
    ) | append "" | str collect "\n" | save --raw $"src/lte($i).rs"
}

# generate the lib.rs
for $i in 0..255 {[
    $"#[cfg\(feature = \"u8lte($i)\")]",
    $"mod lte($i);",
    $"#[cfg\(feature = \"u8lte($i)\")]",
    $"pub use lte($i)::u8lte($i);"
]} | flatten | append "" | str collect "\n" | save --raw "src/lib.rs"

# generate the features
let $features = (for $i in 0..255 { $"u8lte($i): []" } | str collect "\n" | from yaml)
open Cargo.toml | upsert features $features | save Cargo.toml
