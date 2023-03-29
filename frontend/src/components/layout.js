import * as React from "react"
import { Link } from "gatsby"


const Layout = ({ location,  children }) => {
  const rootPath = `${__PATH_PREFIX__}/`
  const isRootPath = location.pathname === rootPath

  let header

  if (isRootPath) {

    header = (
      <Link className="header-link-home" to="/">
        {/* {title} */}
      </Link>
    )
  }

  return (<div>
    
    
    <div className="global-wrapper" data-is-root-path={isRootPath}>
  
      <header >{header}</header>
      <main>{children}</main>
      <footer className="font-sans">
        {/* © {new Date().getFullYear()},  */}
        {/* Made with 🍵 by Tariq */}
      </footer>
    </div>
  </div>
    
  )
}

export default Layout
