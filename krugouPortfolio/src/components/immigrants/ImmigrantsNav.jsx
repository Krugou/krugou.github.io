import React from 'react';

const ImmigrantsNav = ({gameData}) => {
	return (
		<div className='game-nav'>
			<div className='game-stats'>
				<p>Health: {gameData.health}</p>
				<p>Mana: {gameData.mana}</p>
				<p>Experience: {gameData.experience}</p>
			</div>
			<div className='game-controls'>
				<button>Attack</button>
				<button>Defend</button>
				<button>Heal</button>
			</div>
		</div>
	);
};

export default ImmigrantsNav;
