import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  basePath: "/krugou.github.io",
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
