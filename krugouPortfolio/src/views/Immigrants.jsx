import React, {useState, useEffect} from 'react';
import StatusBar from '../components/immigrants/StatusBar';

const Immigrants = () => {
	const [gameData, setGameData] = useState(null);

	useEffect(() => {
		fetch('/path/to/your/gameStart.json')
			.then((response) => response.json())
			.then((data) => setGameData(data))
			.catch((error) => console.error('Error:', error));
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
