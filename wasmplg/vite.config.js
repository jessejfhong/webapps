import { defineConfig } from 'vite';
import { viteStaticCopy } from 'vite-plugin-static-copy';

export default defineConfig({
    base: './',
    publicDir: 'www',
    plugins: [
        viteStaticCopy({
            targets: [
                {
                  src: 'target/wasm32-unknown-unknown/debug/wasmplg.wasm',
                  dest: './'
                }
            ]
        })
    ]
});
