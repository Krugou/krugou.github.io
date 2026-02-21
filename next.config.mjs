/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/admin/:path*',
        destination: 'http://localhost:3000/api/admin/:path*',
      },
    ];
  },
  turbopack: {},
  images: {
    unoptimized: true,
  },

};

export default nextConfig;
