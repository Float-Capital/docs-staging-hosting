import Login from "src/pages/Login";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function LoginPage(props) {
  return (
    <div>
      <HtmlHeader page="Login"></HtmlHeader>
      <Login {...props} />
    </div>
  );
}
