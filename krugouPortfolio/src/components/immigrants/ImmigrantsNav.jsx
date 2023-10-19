import React from 'react';

const ImmigrantsNav = ({gamedata}) => {
	return (
		<div className='bg-blue-500 p-4 text-white'>
			<div className='mb-4'>
				<p className='mb-2'>Health: {gamedata.health}</p>
				<p className='mb-2'>Mana: {gamedata.mana}</p>
				<p className='mb-2'>Experience: {gamedata.experience}</p>
			</div>
			<div className='flex justify-around'>
				<button className='bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded'>
					Attack
				</button>
				<button className='bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded'>
					Defend
				</button>
				<button className='bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded'>
					Heal
				</button>
			</div>
		</div>
	);
};

export default ImmigrantsNav;
