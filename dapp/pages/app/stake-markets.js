import StakeMarkets from "src/pages/StakeMarkets";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function StakePage(props) {
  return (
    <>
      <HtmlHeader page="Stake Markets"></HtmlHeader>
      <StakeMarkets {...props} />
    </>
  );
}
