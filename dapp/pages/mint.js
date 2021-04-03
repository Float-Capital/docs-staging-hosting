import Mint from "src/Mint";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function MintPage(props) {
  return (
    <div>
      <HtmlHeader page="Mint"></HtmlHeader>
      <Mint {...props} />
    </div>
  );
}
