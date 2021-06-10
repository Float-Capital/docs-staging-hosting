import Site from "src/pages/MarketingSite.js";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function Index(props) {
  return (
    <div>
      <HtmlHeader page="Home"></HtmlHeader>
      <Site {...props} />
    </div>
  );
}
