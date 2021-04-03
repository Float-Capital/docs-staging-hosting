import Stake from "src/Stake";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function StakePage(props) {
  return (
    <>
      <HtmlHeader page="Stake"></HtmlHeader>
      <Stake {...props} />
    </>
  );
}
