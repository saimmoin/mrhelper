import { useEffect } from 'react'


import Layout from './Layout'
import { Route, Router, Routes } from 'react-router-dom'
import Home from 'src/Pages/Home'
import SignIn from 'src/Pages/SignIn'
import CampaignExplorer from 'src/Pages/CampaignExplorer'
import Campaign from 'src/Pages/Campaign'
import Navbar from 'src/Componentes/Navbar'

function App() {


  return (
    <div>
      <Navbar />

      {/* <Layout></Layout> */}
      <Routes>
        <Route path="/" element={<Home />}>
          {/* <Route path="*" element={<Navbar />} /> */}
        </Route>
        <Route path="/signin" element={<SignIn />}>
          {/* <Route path="*" element={<Navbar />} /> */}
        </Route>
        <Route path="/campaign/:address" element={<CampaignExplorer />}>
          {/* <Route path="*" element={<Navbar />} /> */}
        </Route>
        <Route path="/campaign" element={<Campaign />}>
          {/* <Route path="*" element={<Navbar />} /> */}
        </Route>
      </Routes>
      {/* </Router> */}
    </div>
  )
}

export default App
