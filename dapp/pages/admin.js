import AdminTestingPortal from "src/components/Testing/Admin/AdminTestingPortal.js";
import HtmlHeader from "src/components/HtmlHeader.js";

export default function AdminPage(props) {
  return (
    <div>
      <HtmlHeader page="Admin"></HtmlHeader>
      <AdminTestingPortal {...props} />
    </div>
  );
}
