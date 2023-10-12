import react from 'react';
import { useNavigate } from "react-router-dom";

const NavList = ( { linkpath } ) => {
    
    const navigate = useNavigate();
    return (
        <li onClick={() => navigate(linkpath)}>
            
        </li>
    );
};

export default NavList;

