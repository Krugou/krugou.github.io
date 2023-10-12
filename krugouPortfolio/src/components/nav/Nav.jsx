import React from 'react';
import NavList from './ul/NavList';

const Nav = () => {
	return (
		<nav>
			<ul>
				<NavList linkpath='/' />
				<NavList linkpath='/about' />
				<NavList linkpath='/projects' />
			</ul>
		</nav>
	);
};

export default Nav;
