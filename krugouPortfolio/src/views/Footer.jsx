
const Footer = () => {
    const currentYear = new Date().getFullYear();

    return (
        <footer>
            <p>&copy; {currentYear} Krugou Portfolio</p>
        </footer>
    );
};

export default Footer;
