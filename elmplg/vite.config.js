import { defineConfig } from 'vite';
import { plugin as elm } from 'vite-plugin-elm';

export default defineConfig({
    base: "./",
    publicDir: 'www',
    plugins: [elm()],
    server: {
        proxy: {
            '/api': {
                target: 'http://localhost:8080',
                changeOrigin: true,
                rewrite: (path) => path.replace(/^\/api/, '')
            }
        }
    }
});