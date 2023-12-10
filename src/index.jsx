import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from './App.jsx'
// import './index.css'
import { WagmiConfig, createConfig } from 'wagmi'
import { polygonMumbai } from 'wagmi/chains'
import { createPublicClient, http } from 'viem'
import { CssBaseline, ThemeProvider } from '@mui/material'
import lightTheme from './config/theme/theme'

const config = createConfig({
  autoConnect: true,
  publicClient: createPublicClient({
    chain: polygonMumbai,
    transport: http(),
  }),
})

ReactDOM.createRoot(document.getElementById('root')).render(
  <WagmiConfig config={config}>
    <ThemeProvider theme={lightTheme}>
      <CssBaseline enableColorScheme />
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </ThemeProvider>
  </WagmiConfig>,
)
