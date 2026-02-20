import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import '../i18n';
import { AuthProvider } from '../context/AuthContext';
import { GameProvider } from '../context/GameContext';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'The Immigrants - Space Colonization',
  description:
    'An advanced event-driven incremental game about population movement and territory expansion.',
};

const RootLayout = ({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) => (
  <html lang="en">
      <body
        className={`${inter.className} min-h-screen bg-cinematic-bg text-slate-100 overflow-x-hidden pt-8`}
      >
        <AuthProvider>
          <GameProvider>{children}</GameProvider>
        </AuthProvider>
      </body>
  </html>
);

export default RootLayout;
