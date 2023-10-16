const IntroText = () => {
	return (
		<section className='bg-blue-500 p-4'>
			<div className='container mx-auto'>
				<div className='flex flex-wrap'>
					<div className='w-full'>
						<h1 className='text-4xl text-white'>
							<span className='block'>Aleksi Nokelainen</span>
							<span className='block'>Full stack Developer</span>
						</h1>
						<p className='text-xl text-white mt-2'>
							<span className='mr-2'>HTML</span>
							<span className='mr-2'>CSS</span>
							<span className='mr-2'>JavaScript</span>
							<span className='mr-2'>React</span>
							<span className='mr-2'>Node</span>
						</p>
					</div>
				</div>
			</div>
		</section>
	);
};

export default IntroText;
