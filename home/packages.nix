{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    bun
    deno
    lua-language-server
    nixd
    typescript-language-server
    svelte-language-server
    tailwindcss-language-server
  ];
}
