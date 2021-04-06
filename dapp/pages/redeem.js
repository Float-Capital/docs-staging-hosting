import Redeem from "src/Redeem";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function RedeemPage(props) {
  return (
    <div>
      <HtmlHeader page="Redeem"></HtmlHeader>
      <Redeem {...props} />
    </div>
  );
}
