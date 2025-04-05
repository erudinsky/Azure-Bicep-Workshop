module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'http://localhost:5001',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }