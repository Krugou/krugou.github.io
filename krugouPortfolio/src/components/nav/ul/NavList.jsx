import React from 'react';
import {useNavigate} from 'react-router-dom';

const NavList = ({linkpath}) => {
	const navigate = useNavigate();
	return (
		<li
			className='text-black  cursor-pointer'
			onClick={() => navigate('/' + linkpath)}>
			{linkpath}
		</li>
	);
};

export default NavList;
