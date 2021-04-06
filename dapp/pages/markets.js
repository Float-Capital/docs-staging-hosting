import Markets from "src/components/Markets/MarketsList";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function MarketsPage(props) {
  return (
    <div>
      <HtmlHeader page="Markets"></HtmlHeader>
      <Markets {...props} />
    </div>
  );
}
