import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom", // Gunakan jsdom sebagai lingkungan DOM
    setupFiles: "./setupTests.js", // File setup untuk menyiapkan pengujian
    globals: true, // Memastikan `expect` tersedia secara global
  },
});
