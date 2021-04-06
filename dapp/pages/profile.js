import User from "src/User";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function ProfilePage(props) {
  return (
    <div>
      <HtmlHeader page="Profile"></HtmlHeader>
      <User {...props} />
    </div>
  );
}
