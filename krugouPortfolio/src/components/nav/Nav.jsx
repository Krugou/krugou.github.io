import React from 'react';
import NavList from './ul/NavList';

const Nav = () => {
	return (
		<nav className='bg-blue-500 p-4'>
			<ul className='flex justify-around'>
				<NavList linkpath='home' />
				<NavList linkpath='about' />
				<NavList linkpath='projects' />
				<NavList linkpath='game' />
			</ul>
		</nav>
	);
};

export default Nav;
