import React from 'react';

const StatusBar = ({gamedata}) => {
	return (
		<div className='flex flex-col space-y-2 p-4 bg-gray-800 text-white'>
			<div className='flex items-center'>
				<div
					className='bg-green-500 h-4'
					style={{width: `${gamedata.health}%`}}></div>
				<span className='ml-2'>{gamedata.health}</span>
			</div>
			<div className='flex items-center'>
				<div
					className='bg-blue-500 h-4'
					style={{width: `${gamedata.mana}%`}}></div>
				<span className='ml-2'>{gamedata.mana}</span>
			</div>
			<div className='flex items-center'>
				<div
					className='bg-yellow-500 h-4'
					style={{width: `${gamedata.experience}%`}}></div>
				<span className='ml-2'>{gamedata.experience}</span>
			</div>
		</div>
	);
};

export default StatusBar;
