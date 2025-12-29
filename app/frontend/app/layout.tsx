import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Quzuu DevOps',
  description: 'VPS Starter Kit',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
