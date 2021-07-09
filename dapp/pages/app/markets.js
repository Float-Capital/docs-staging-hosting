import Markets from "src/pages/Markets";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function MarketsPage(props) {
  return (
    <div>
      <HtmlHeader page="Markets"></HtmlHeader>
      <Markets {...props} />
    </div>
  );
}
