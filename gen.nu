for $i in 0..255 {
    ($"#[repr\(u8)] pub enum U0to($i) {"
        | append (0..$i | each { $"    _($in) = ($in)," })
        | append "}"
    ) | str collect "\n" | save --raw $"src/_($i).rs"
}

for $i in 0..255 {
    $"mod _($i);\npub use _($i)::U0to($i);\n"
} | str collect | save --raw "src/lib.rs"
