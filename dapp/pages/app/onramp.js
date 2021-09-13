import FiatOnramp from "src/pages/FiatOnramp";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function FiatOnrampPage(props) {
  return (
    <div>
      <HtmlHeader page="Fiat Onramp" />
      <FiatOnramp {...props} />
    </div>
  );
}
