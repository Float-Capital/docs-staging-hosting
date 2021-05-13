import Dashboard from "src/pages/Dashboard";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function DashboardPage(props) {
  return (
    <div>
      <HtmlHeader page="Dashboard"></HtmlHeader>
      <Dashboard {...props} />
    </div>
  );
}
