import React from 'react';
import {Route, BrowserRouter as Router, Routes} from 'react-router-dom';
import Footer from './views/Footer';
import Header from './views/Header';
import Immigrants from './views/Immigrants';
import LandingZone from './views/LandingZone';

const App = () => {
	return (
		<Router basename={import.meta.env.BASE_URL}>
			<Header />
			<Routes>
				<Route
					path='/'
					element={<LandingZone />}
				/>
				<Route
					path='/home'
					element={<LandingZone />}
				/>
				<Route
					path='/about'
					element={<h1>About</h1>}
				/>
				<Route
					path='/projects'
					element={<h1>Projects</h1>}
				/>
				<Route
					path='/contact'
					element={<h1>Contact</h1>}
				/>
				<Route
					path='*'
					element={<h1>Not Found</h1>}
				/>
				<Route
					path='/game'
					element={<Immigrants />}
				/>
			</Routes>
			<Footer />
		</Router>
	);
};

export default App;
