import React from 'react';

const StatusBar = ({health, mana, experience}) => {
	return (
		<div className='flex flex-col space-y-2'>
			<div className='flex items-center'>
				<div
					className='bg-green-500'
					style={{width: `${health}%`}}></div>
				<span className='ml-2'>{health}</span>
			</div>
			<div className='flex items-center'>
				<div
					className='bg-blue-500'
					style={{width: `${mana}%`}}></div>
				<span className='ml-2'>{mana}</span>
			</div>
			<div className='flex items-center'>
				<div
					className='bg-yellow-500'
					style={{width: `${experience}%`}}></div>
				<span className='ml-2'>{experience}</span>
			</div>
		</div>
	);
};

export default StatusBar;
