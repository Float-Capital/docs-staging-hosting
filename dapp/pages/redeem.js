import RedeemOld from "src/RedeemOld";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function RedeemPage(props) {
  return (
    <div>
      <HtmlHeader page="Redeem"></HtmlHeader>
      <RedeemOld {...props} />
    </div>
  );
}
