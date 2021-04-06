import Dashboard from "src/Dashboard";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function DashboardPage(props) {
  return (
    <div>
      <HtmlHeader page="Dashboard"></HtmlHeader>
      <Dashboard {...props} />
    </div>
  );
}
