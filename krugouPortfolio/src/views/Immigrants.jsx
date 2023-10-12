import React from 'react';

const Immigrants = () => {
	const startGame = () => {
		alert('Starting the game...');
		// Add your game logic here
	};

	return (
		<div>
			<h1>Welcome to the Immigrants Game!</h1>
			<p>Press the button below to start the game.</p>
			<button onClick={startGame}>Start Game</button>
		</div>
	);
};

export default Immigrants;
