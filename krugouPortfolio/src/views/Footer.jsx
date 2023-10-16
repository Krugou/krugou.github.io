const Footer = () => {
	const currentYear = new Date().getFullYear();

	return (
		<footer className='bg-blue-500 p-4 text-center text-white'>
			<p className='m-0'>&copy; {currentYear} Krugou Portfolio</p>
		</footer>
	);
};

export default Footer;
