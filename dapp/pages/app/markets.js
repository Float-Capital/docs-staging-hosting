import IndexRes from "src/pages/Home.js";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function Index(props) {
  return (
    <div>
      <HtmlHeader page="Home"></HtmlHeader>
      <IndexRes {...props} />
    </div>
  );
}
