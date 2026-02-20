import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  images: {
    unoptimized: true,
  },
  // if a webpack configuration is added by plugins later, include blank turbopack
  turbopack: {},
};

export default nextConfig;
