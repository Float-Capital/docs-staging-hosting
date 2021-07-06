import Stats from "src/pages/Stats";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function DashboardPage(props) {
  return (
    <div>
      <HtmlHeader page="Stats"></HtmlHeader>
      <Stats {...props} />
    </div>
  );
}
