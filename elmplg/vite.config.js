import { defineConfig } from 'vite';
import { plugin as elm } from 'vite-plugin-elm';

export default defineConfig({
    publicDir: 'www',
    plugins: [elm()],
    server: {
        proxy: {
            '/api': {
                target: 'http://localhost:5155',
                changeOrigin: true
            }
        }
    }
});