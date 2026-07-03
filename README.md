# Wallshader: A custom GLSL shader as a desktop background!

This is *my actual computer's background*, a GLSL shader that runs in parallel for every pixel as a wlr layer shell background to produce a slow-moving, reactive, subtly alive desktop wallpaper.

## Installation / Usage

If you're on x86_64 ~~or aarch64~~ (cross-compilation is being weird), there's a release on the GitHub page. Otherwise, just clone the repo, [install Rust](https://rust-lang.org/tools/install/) if necessary, and run the project with `cargo r`. 

A couple of things to note: due to the nature of its implementation, this project can *only* be used on Linux Wayland compositors that support the wlr_layer_shell protocol. However, the wallpaper.glsl code contains most of the information necessary to translate that to a different platform. 

Also, this program is designed for my 16:10 aspect ratio screen. It should otherwise be resolution independent, but other aspect ratios may cause odd errors that I can't exactly account for.
