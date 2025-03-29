import { OhVueIcon, addIcons } from "oh-vue-icons";
import { 
  RiDashboardFill,    // Dashboard
  RiUser3Fill,        // Users
  RiUserStarFill,     // Experts
  RiFileTextFill,     // Missions
  FaHandshake,        // Deals
  RiStackFill,        // Professions
  GiGraduateCap,      // Skills
  RiMessage2Fill,     // Conversations
  BiStarFill,         // Reviews
  RiSettings4Fill,    // Settings
  RiDatabase2Fill,    // Storage
  RiHome4Fill,        // Home (mobile)
  RiArrowLeftLine,    // Back to site
  RiLogoutBoxRLine,   // Logout
  RiMoreFill,         // More
  RiCloseFill,        // Close
  RiShieldUserFill,   // Admin shield
  HiSolidUsers,       // Users group
  BiCodeSlash,        // Skills
  RiBriefcase4Fill,   // Missions
  RiBuilding4Fill,    // Companies
  RiFileList3Fill,    // Documents
  RiChat1Fill,        // Chat
  RiStarFill,         // Star
  RiSettings3Fill,    // Settings
  RiArchiveFill,      // Archive
  RiMenuFill,         // Menu
  RiSearchLine,       // Search
  RiNotification3Fill, // Notifications
  RiArrowRightSLine, 
  MdWorkoutlineTwotone,
  BiFileEarmarkText, // Arrow right
  RiCheckFill,        // Check
  RiErrorWarningFill, // Warning
  RiUserLine,         // Users (alternative)
  RiUserFill,        // Users (group)
  RiSettings2Line,    // Parameters
  RiSettings5Fill,    // Parameters (alternative)
  RiUserSettingsLine, // User settings
  RiTeamFill,         // Team/Users
  RiAdminFill,        // Admin
  RiToolsFill,        // Tools/Parameters
  RiListSettingsFill ,
  LaGraduationCapSolid ,
  HiUsers,
  OiStack,
  BiStar,
  BiChatText,
  RiDashboard3Line,
  LaClock,
  IoBriefcaseOutline,
  FaRegularHandshake// List settings
} from "oh-vue-icons/icons";

// Ajouter les icônes
addIcons(
  RiDashboardFill,
  RiUser3Fill,
  RiUserStarFill,
  RiFileTextFill,
  FaHandshake,
  RiStackFill,
  GiGraduateCap,
  RiMessage2Fill,
  BiStarFill,
  RiSettings4Fill,
  BiChatText,
  LaClock,
  IoBriefcaseOutline,
  RiDashboard3Line,
  RiDatabase2Fill,
  RiHome4Fill,
  RiArrowLeftLine,
  RiLogoutBoxRLine,
  MdWorkoutlineTwotone,
  RiMoreFill,
  RiCloseFill,
  BiFileEarmarkText,
  HiUsers,
  OiStack,
  BiStar,
  RiShieldUserFill,
  HiSolidUsers,
  BiCodeSlash,
  RiBriefcase4Fill,
  RiBuilding4Fill,
  RiFileList3Fill,
  RiChat1Fill,
  RiStarFill,
  RiSettings3Fill,
  RiArchiveFill,
  RiMenuFill,
  RiSearchLine,
  RiNotification3Fill,
  RiArrowRightSLine,
  RiCheckFill,
  RiErrorWarningFill,
  RiUserLine,
  RiUserFill,
  FaRegularHandshake,
  LaGraduationCapSolid,
  RiSettings2Line,
  RiSettings5Fill,
  RiUserSettingsLine,
  RiTeamFill,
  RiAdminFill,
  RiToolsFill,
  RiListSettingsFill
);

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.component("v-icon", OhVueIcon);
});
