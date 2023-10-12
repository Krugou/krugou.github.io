import React, {useState, useEffect} from 'react';
import StatusBar from '../components/immigrants/StatusBar';

const Immigrants = () => {
	const [gameData, setGameData] = useState(null);

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
		setGameData(devData);
	}, []);

	if (!gameData) {
		return <div>Loading...</div>;
	}

	return (
		<>
			<StatusBar
				health={gameData.health}
				mana={gameData.mana}
				experience={gameData.experience}
			/>
			<MainView />
			<ImmigrantsNav />
		</>
	);
};

export default Immigrants;
