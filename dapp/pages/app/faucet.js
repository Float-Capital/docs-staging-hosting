import AaveDaiFaucet from "src/pages/AaveDaiFaucet";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function DashboardPage(props) {
  return (
    <div>
      <HtmlHeader page="Aave DAI Faucet">
        <meta name="robots" content="noindex" />
      </HtmlHeader>
      <AaveDaiFaucet {...props} />
    </div>
  );
}
