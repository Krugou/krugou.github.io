import React, {useEffect, useState} from 'react';
import ImmigrantsNav from '../components/immigrants/ImmigrantsNav';

import MainView from '../components/immigrants/MainView';
import StatusBar from '../components/immigrants/StatusBar';

const Immigrants = () => {
	const [gamedata, setGamedata] = useState(null);

	// Development data for testing
	const devData = {
		health: 100,
		mana: 50,
		experience: 0,
	};

	useEffect(() => {
		// Commenting out the fetch call and using devData for testing
		// fetch('/path/to/your/gameStart.json')
		//     .then(response => response.json())
		//     .then(data => setGameData(data))
		//     .catch(error => console.error('Error:', error));
		setGamedata(devData);
	}, []);

	if (!gamedata) {
		return <div>Loading...</div>;
	}

	return (
		<>
			<StatusBar gamedata={gamedata} />
			<MainView />
			<ImmigrantsNav gamedata={gamedata} />
		</>
	);
};

export default Immigrants;
